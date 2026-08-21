import Sound
import lean_certs.cert_13_24

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H13_gt_24_kernel : ¬ ∃ t : List Nat, admissible 13 t = true ∧ diameter t ≤ 24 := by
  exact certValidRoot_sound (k := 13) (d := 24) (c := cert_13_24) (by decide)
