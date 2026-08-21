import Sound
import lean_certs.cert_7_16

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H7_gt_16_kernel : ¬ ∃ t : List Nat, admissible 7 t = true ∧ diameter t ≤ 16 := by
  exact certValidRoot_sound (k := 7) (d := 16) (c := cert_7_16) (by decide)
