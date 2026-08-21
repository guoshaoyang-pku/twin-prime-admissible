import Sound
import lean_certs.cert_39_98

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_98_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 39) (d := 98) (c := cert_39_98) (by decide)
