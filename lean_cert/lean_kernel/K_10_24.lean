import Sound
import lean_certs.cert_10_24

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H10_gt_24_kernel : ¬ ∃ t : List Nat, admissible 10 t = true ∧ diameter t ≤ 24 := by
  exact certValidRoot_sound (k := 10) (d := 24) (c := cert_10_24) (by decide)
