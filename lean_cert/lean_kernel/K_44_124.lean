import Sound
import lean_certs.cert_44_124

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_124_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 44) (d := 124) (c := cert_44_124) (by decide)
