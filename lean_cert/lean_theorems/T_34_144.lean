import Sound
import lean_certs.cert_34_144

open CertVerify

theorem H34_gt_144 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 144 := by
  exact certValidRoot_sound (k := 34) (d := 144) (c := cert_34_144) (by native_decide)
