import Sound
import lean_certs.cert_30_58

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H30_gt_58_kernel : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 58 := by
  exact certValidRoot_sound (k := 30) (d := 58) (c := cert_30_58) (by decide)
