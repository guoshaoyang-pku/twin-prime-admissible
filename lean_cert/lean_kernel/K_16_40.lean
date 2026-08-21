import Sound
import lean_certs.cert_16_40

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H16_gt_40_kernel : ¬ ∃ t : List Nat, admissible 16 t = true ∧ diameter t ≤ 40 := by
  exact certValidRoot_sound (k := 16) (d := 40) (c := cert_16_40) (by decide)
