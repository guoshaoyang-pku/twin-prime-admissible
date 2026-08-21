import Sound
import lean_certs.cert_24_64

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H24_gt_64_kernel : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 64 := by
  exact certValidRoot_sound (k := 24) (d := 64) (c := cert_24_64) (by decide)
