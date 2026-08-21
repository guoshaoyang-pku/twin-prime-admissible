import Sound
import lean_certs.cert_26_52

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H26_gt_52_kernel : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 52 := by
  exact certValidRoot_sound (k := 26) (d := 52) (c := cert_26_52) (by decide)
