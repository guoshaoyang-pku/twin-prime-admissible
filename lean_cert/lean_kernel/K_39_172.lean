import Sound
import lean_certs.cert_39_172

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H39_gt_172_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 172 := by
  exact certValidRoot_sound (k := 39) (d := 172) (c := cert_39_172) (by decide)
