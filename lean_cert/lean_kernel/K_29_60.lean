import Sound
import lean_certs.cert_29_60

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H29_gt_60_kernel : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 60 := by
  exact certValidRoot_sound (k := 29) (d := 60) (c := cert_29_60) (by decide)
