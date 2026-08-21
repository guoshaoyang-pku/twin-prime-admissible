import Sound
import lean_certs.cert_25_90

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H25_gt_90_kernel : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 90 := by
  exact certValidRoot_sound (k := 25) (d := 90) (c := cert_25_90) (by decide)
