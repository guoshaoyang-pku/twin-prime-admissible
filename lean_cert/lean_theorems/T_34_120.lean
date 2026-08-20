import Sound
import lean_certs.cert_34_120

open CertVerify

theorem H34_gt_120 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 34) (d := 120) (c := cert_34_120) (by native_decide)
