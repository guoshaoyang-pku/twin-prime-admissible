import Sound
import lean_certs.cert_34_118

open CertVerify

theorem H34_gt_118 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 34) (d := 118) (c := cert_34_118) (by native_decide)
