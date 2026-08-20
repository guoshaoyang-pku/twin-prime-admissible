import Sound
import lean_certs.cert_34_150

open CertVerify

theorem H34_gt_150 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 150 := by
  exact certValidRoot_sound (k := 34) (d := 150) (c := cert_34_150) (by native_decide)
