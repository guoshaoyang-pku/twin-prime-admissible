import Sound
import lean_certs.cert_49_134

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_134_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 49) (d := 134) (c := cert_49_134) (by decide)
