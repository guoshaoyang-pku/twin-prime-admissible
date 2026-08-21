import Sound
import lean_certs.cert_40_180

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H40_gt_180_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 180 := by
  exact certValidRoot_sound (k := 40) (d := 180) (c := cert_40_180) (by decide)
