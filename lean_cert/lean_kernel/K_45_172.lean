import Sound
import lean_certs.cert_45_172

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_172_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 172 := by
  exact certValidRoot_sound (k := 45) (d := 172) (c := cert_45_172) (by decide)
