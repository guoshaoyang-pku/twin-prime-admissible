import Sound
import lean_certs.cert_15_40

open CertVerify

theorem H15_gt_40 : ¬ ∃ t : List Nat, admissible 15 t = true ∧ diameter t ≤ 40 := by
  exact certValidRoot_sound (k := 15) (d := 40) (c := cert_15_40) (by native_decide)
