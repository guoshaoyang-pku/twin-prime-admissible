import Sound
import lean_certs.cert_37_150

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_150_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 150 := by
  exact certValidRoot_sound (k := 37) (d := 150) (c := cert_37_150) (by decide)
