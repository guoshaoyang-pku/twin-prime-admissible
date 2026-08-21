import Sound
import lean_certs.cert_15_40

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H15_gt_40_kernel : ¬ ∃ t : List Nat, admissible 15 t = true ∧ diameter t ≤ 40 := by
  exact certValidRoot_sound (k := 15) (d := 40) (c := cert_15_40) (by decide)
