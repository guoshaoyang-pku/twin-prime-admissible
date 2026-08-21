import Sound
import lean_certs.cert_46_134

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_134_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 46) (d := 134) (c := cert_46_134) (by decide)
