import Sound
import lean_certs.cert_16_50

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H16_gt_50_kernel : ¬ ∃ t : List Nat, admissible 16 t = true ∧ diameter t ≤ 50 := by
  exact certValidRoot_sound (k := 16) (d := 50) (c := cert_16_50) (by decide)
