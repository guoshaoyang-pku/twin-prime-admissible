import Sound
import lean_certs.cert_42_192

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H42_gt_192_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 192 := by
  exact certValidRoot_sound (k := 42) (d := 192) (c := cert_42_192) (by decide)
