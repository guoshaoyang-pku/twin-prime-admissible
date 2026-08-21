import Sound
import lean_certs.cert_18_60

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H18_gt_60_kernel : ¬ ∃ t : List Nat, admissible 18 t = true ∧ diameter t ≤ 60 := by
  exact certValidRoot_sound (k := 18) (d := 60) (c := cert_18_60) (by decide)
