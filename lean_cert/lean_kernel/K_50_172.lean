import Sound
import lean_certs.cert_50_172

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_172_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 172 := by
  exact certValidRoot_sound (k := 50) (d := 172) (c := cert_50_172) (by decide)
