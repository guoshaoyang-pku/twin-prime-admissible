import Sound
import lean_certs.cert_20_52

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H20_gt_52_kernel : ¬ ∃ t : List Nat, admissible 20 t = true ∧ diameter t ≤ 52 := by
  exact certValidRoot_sound (k := 20) (d := 52) (c := cert_20_52) (by decide)
