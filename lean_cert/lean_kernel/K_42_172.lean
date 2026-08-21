import Sound
import lean_certs.cert_42_172

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_172_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 172 := by
  exact certValidRoot_sound (k := 42) (d := 172) (c := cert_42_172) (by decide)
