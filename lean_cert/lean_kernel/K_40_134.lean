import Sound
import lean_certs.cert_40_134

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_134_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 40) (d := 134) (c := cert_40_134) (by decide)
