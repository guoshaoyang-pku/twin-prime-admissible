import Sound
import lean_certs.cert_39_124

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_124_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 39) (d := 124) (c := cert_39_124) (by decide)
