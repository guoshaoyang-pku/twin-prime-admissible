import Sound
import lean_certs.cert_38_158

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H38_gt_158_kernel : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 158 := by
  exact certValidRoot_sound (k := 38) (d := 158) (c := cert_38_158) (by decide)
