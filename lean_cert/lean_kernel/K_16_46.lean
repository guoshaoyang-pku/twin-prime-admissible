import Sound
import lean_certs.cert_16_46

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H16_gt_46_kernel : ¬ ∃ t : List Nat, admissible 16 t = true ∧ diameter t ≤ 46 := by
  exact certValidRoot_sound (k := 16) (d := 46) (c := cert_16_46) (by decide)
