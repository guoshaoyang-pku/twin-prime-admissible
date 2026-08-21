import Sound
import lean_certs.cert_20_40

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H20_gt_40_kernel : ¬ ∃ t : List Nat, admissible 20 t = true ∧ diameter t ≤ 40 := by
  exact certValidRoot_sound (k := 20) (d := 40) (c := cert_20_40) (by decide)
