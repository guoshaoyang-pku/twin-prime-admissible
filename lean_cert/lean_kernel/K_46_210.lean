import Sound
import lean_certs.cert_46_210

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H46_gt_210_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 210 := by
  exact certValidRoot_sound (k := 46) (d := 210) (c := cert_46_210) (by decide)
