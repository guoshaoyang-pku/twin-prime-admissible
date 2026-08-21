import Sound
import lean_certs.cert_36_124

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H36_gt_124_kernel : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 36) (d := 124) (c := cert_36_124) (by decide)
