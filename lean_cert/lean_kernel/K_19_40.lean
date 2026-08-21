import Sound
import lean_certs.cert_19_40

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H19_gt_40_kernel : ¬ ∃ t : List Nat, admissible 19 t = true ∧ diameter t ≤ 40 := by
  exact certValidRoot_sound (k := 19) (d := 40) (c := cert_19_40) (by decide)
