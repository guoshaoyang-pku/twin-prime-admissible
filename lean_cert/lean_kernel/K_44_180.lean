import Sound
import lean_certs.cert_44_180

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_180_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 180 := by
  exact certValidRoot_sound (k := 44) (d := 180) (c := cert_44_180) (by decide)
