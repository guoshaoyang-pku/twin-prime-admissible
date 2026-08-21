import Sound
import lean_certs.cert_24_84

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H24_gt_84_kernel : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 24) (d := 84) (c := cert_24_84) (by decide)
