import Sound
import lean_certs.cert_25_98

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H25_gt_98_kernel : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 25) (d := 98) (c := cert_25_98) (by decide)
