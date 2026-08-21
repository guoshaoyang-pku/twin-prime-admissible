import Sound
import lean_certs.cert_25_94

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H25_gt_94_kernel : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 25) (d := 94) (c := cert_25_94) (by decide)
