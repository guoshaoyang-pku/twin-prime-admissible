import Sound
import lean_certs.cert_48_172

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_172_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 172 := by
  exact certValidRoot_sound (k := 48) (d := 172) (c := cert_48_172) (by decide)
