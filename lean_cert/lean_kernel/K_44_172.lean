import Sound
import lean_certs.cert_44_172

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_172_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 172 := by
  exact certValidRoot_sound (k := 44) (d := 172) (c := cert_44_172) (by decide)
