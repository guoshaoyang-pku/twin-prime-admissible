import Sound
import lean_certs.cert_48_124

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_124_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 48) (d := 124) (c := cert_48_124) (by decide)
