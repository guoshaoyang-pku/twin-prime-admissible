import Sound
import lean_certs.cert_24_46

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H24_gt_46_kernel : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 46 := by
  exact certValidRoot_sound (k := 24) (d := 46) (c := cert_24_46) (by decide)
