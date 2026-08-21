import Sound
import lean_certs.cert_29_124

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H29_gt_124_kernel : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 29) (d := 124) (c := cert_29_124) (by decide)
