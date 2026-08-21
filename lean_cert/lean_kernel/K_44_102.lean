import Sound
import lean_certs.cert_44_102

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_102_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 44) (d := 102) (c := cert_44_102) (by decide)
