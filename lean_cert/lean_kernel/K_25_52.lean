import Sound
import lean_certs.cert_25_52

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H25_gt_52_kernel : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 52 := by
  exact certValidRoot_sound (k := 25) (d := 52) (c := cert_25_52) (by decide)
