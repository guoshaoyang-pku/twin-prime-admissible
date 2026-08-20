import Sound
import lean_certs.cert_34_100

open CertVerify

theorem H34_gt_100 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 34) (d := 100) (c := cert_34_100) (by native_decide)
