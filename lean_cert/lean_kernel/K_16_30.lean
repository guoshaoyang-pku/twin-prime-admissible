import Sound
import lean_certs.cert_16_30

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H16_gt_30_kernel : ¬ ∃ t : List Nat, admissible 16 t = true ∧ diameter t ≤ 30 := by
  exact certValidRoot_sound (k := 16) (d := 30) (c := cert_16_30) (by decide)
