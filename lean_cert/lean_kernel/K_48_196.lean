import Sound
import lean_certs.cert_48_196

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_196_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 196 := by
  exact certValidRoot_sound (k := 48) (d := 196) (c := cert_48_196) (by decide)
