import Sound
import lean_certs.cert_17_46

open CertVerify

theorem H17_gt_46 : ¬ ∃ t : List Nat, admissible 17 t = true ∧ diameter t ≤ 46 := by
  exact certValidRoot_sound (k := 17) (d := 46) (c := cert_17_46) (by native_decide)
