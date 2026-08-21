import Sound
import lean_certs.cert_22_60

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H22_gt_60_kernel : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 60 := by
  exact certValidRoot_sound (k := 22) (d := 60) (c := cert_22_60) (by decide)
