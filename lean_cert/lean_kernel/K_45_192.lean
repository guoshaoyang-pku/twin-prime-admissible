import Sound
import lean_certs.cert_45_192

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_192_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 192 := by
  exact certValidRoot_sound (k := 45) (d := 192) (c := cert_45_192) (by decide)
