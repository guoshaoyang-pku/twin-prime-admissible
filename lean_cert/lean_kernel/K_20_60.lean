import Sound
import lean_certs.cert_20_60

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H20_gt_60_kernel : ¬ ∃ t : List Nat, admissible 20 t = true ∧ diameter t ≤ 60 := by
  exact certValidRoot_sound (k := 20) (d := 60) (c := cert_20_60) (by decide)
