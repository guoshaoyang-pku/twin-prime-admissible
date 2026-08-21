import Sound
import lean_certs.cert_42_158

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_158_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 158 := by
  exact certValidRoot_sound (k := 42) (d := 158) (c := cert_42_158) (by decide)
